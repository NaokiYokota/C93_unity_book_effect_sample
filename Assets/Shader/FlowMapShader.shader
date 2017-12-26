Shader "Custom/FlowMapShader"
{
	Properties
	{
		_MainTex ("Main", 2D) = "white" {}
		_FlowMap ("FlowMap",2D) = "white"{}
		_FlowMapSpeed ("FlowMapSpeed",Range(-0.5,0.5)) = 0
	}

		SubShader {
	        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
	        Blend SrcAlpha OneMinusSrcAlpha
	        Cull Off Lighting Off ZWrite Off Fog { Color (0,0,0,0) }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;

			sampler2D _FlowMap; float4 _FlowMap_ST;
			fixed _FlowMapSpeed;
	
			struct appdata
			{
				float4 vertex : POSITION;
				float4 uv : TEXCOORD0;
				float4 vertexColor : COLOR;
			};

			struct v2f
			{
				float4 uv : TEXCOORD0;
				float2 flowMapValue : TEXCOORD1;
				float4 vertex : SV_POSITION;
				float4 color : COLOR;
			};

		
			v2f vert (appdata v)
			{
				v2f o;
				o.color = v.vertexColor;
				o.vertex = UnityObjectToClipPos(v.vertex);
				float2 main_uv = TRANSFORM_TEX(v.uv, _MainTex);
			  	o.uv = float4(main_uv,v.uv.b,v.uv.a);

			  	float fadeTime = saturate(1.0f - v.uv.b);
			  	float phase0 = frac(fadeTime * 0.5f + 0.5f);
                float phase1 = frac(fadeTime * 0.5f + 1.0f);
                o.flowMapValue = float2(phase0, phase1);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
			    float4 flow = tex2D(_FlowMap,i.uv);
			    float2 flowDir = flow * 2.0f - 1.0f;
			    flowDir *= _FlowMapSpeed;
				
                half4 tex0 = tex2D(_MainTex, i.uv.rg + flowDir.xy * i.flowMapValue.r);
                half4 tex1 = tex2D(_MainTex, i.uv.rg + flowDir.xy * i.flowMapValue.g);

                float flowLerp = abs((0.5f - i.flowMapValue.g) / 0.5f);
                fixed4 finalColor = lerp(tex0, tex1, flowLerp);

                finalColor.rgb = finalColor.rgb * i.color.rgb;
                finalColor.a = saturate(finalColor.a * i.color.a);
				return finalColor;
			}
			ENDCG
		}
	}
}
