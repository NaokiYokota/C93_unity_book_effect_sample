Shader "Custom/SharpenShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_KezuriTex ("KezuriTexture",2D) = "white"{}
		_Power ("Power", Range(0, 1)) = 1

	}
	SubShader
	{
	   Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }		

		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag


			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float4 color : COLOR;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 color : COLOR;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _KezuriTex;
			float4 _KezuriTex_ST;
			float _Power;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.color = v.color;
				return o;
			}
			
			float4 frag (v2f i) : SV_Target
			{
			    float4 _main_color = tex2D(_MainTex,TRANSFORM_TEX(i.uv, _MainTex));
			    float3 finalColor = _main_color.rgb * i.color.rgb;
			    float4 _kezuri_color = tex2D(_KezuriTex,TRANSFORM_TEX(i.uv, _KezuriTex));
			    float kezuri_alpha = frac((_Time.g * _Power));
			    float final_alpha = saturate(_kezuri_color.r - kezuri_alpha);
			    return float4(finalColor, _main_color.a * i.color.a * final_alpha);
			}
			ENDCG
		}
	}
}
