Shader "Custom/DistortionShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_DistTex ("DistTexture", 2D) = "white" {}
		_MaskTex ("MaskTexture", 2D) = "white" {}
		_PowerX ("Power X軸", Range(-1,1)) = 0
		_PowerY ("Power Y軸", Range(-1,1)) = 0
		_ScrollX ("スクロール X軸 ", Range(-1,1)) = 0
		_ScrollY ("スクロール Y軸 ", Range(-1,1)) = 0
	}
	SubShader
	{
		Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
		LOD 100

		Pass
		{
		    Blend SrcAlpha OneMinusSrcAlpha
		    ZWrite Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float4 uv : TEXCOORD0;
				float4 vertexColor : COLOR;
			};

			struct v2f
			{
				float2 uv0 : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 vertexColor : COLOR;
				float2 uv1 : TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _DistTex; float4 _DistTex_ST;
			sampler2D _MaskTex; float4 _MaskTex_ST;
			float _PowerX;
			float _PowerY;
			float _ScrollX;
			float _ScrollY;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertexColor = v.vertexColor;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv0 = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv1 = (v.uv + (_Time.g * float2(_ScrollX, _ScrollY)));
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
			    float4 dist_color = tex2D(_DistTex,TRANSFORM_TEX(i.uv1, _DistTex));
                float4 mask_color = tex2D(_MaskTex,TRANSFORM_TEX(i.uv0, _MaskTex));
                float2 main_uv = (i.uv0 + ((float2(dist_color.r,dist_color.g) * mask_color.a) * float2(_PowerX, _PowerY)));
                float4 main_color = tex2D(_MainTex, TRANSFORM_TEX(main_uv, _MainTex));
                return main_color;

                float3 finalColor = main_color.rgb * i.vertexColor.rgb;
                fixed4 finalRGBA = fixed4(finalColor,main_color.a * i.vertexColor.a);
                return finalRGBA;
			}
			ENDCG
		}
	}
}
