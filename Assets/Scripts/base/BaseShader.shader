// Shader 시작. 셰이더의 폴더와 이름을 여기서 결정합니다.
Shader "URPTraining/URPBasic"
{
	Properties
	{
		// Properties Block : 셰이더에서 사용할 변수를 선언하고 이를 material inspector에 노출시킵니다
		_TintColor("Color", Color) = (1,1,1,1)
		_Intensity("Range Sample", Range(0, 1)) = 0.5
		_MainTex("RGB(Texture)", 2D) = "white" {}
	}

	
	SubShader
	{
		Tags
		{
			//Render type과 Render Queue를 여기서 결정합니다.
			"RenderPipeline" = "UniversalPipeline"
			"RenderType" = "Opaque"
			"Queue" = "Geometry"
		}
		Pass
		{
			Name "Universal Forward"
			Tags { "LightMode" = "UniversalForward" }
			HLSLPROGRAM
			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x
			#pragma vertex vert
			#pragma fragment frag

			//cg shader는 .cginc를 hlsl shader는 .hlsl을 include하게 됩니다.
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			//vertex buffer에서 읽어올 정보를 선언합니다.
			struct VertexInput
			{
				float4 vertex	: POSITION;
				float4 color	: COLOR;
				float2 uv		: TEXCOORD0;

			};
		
			//보간기를 통해 버텍스 셰이더에서 픽셀 셰이더로 전달할 정보를 선언합니다.
			struct VertexOutput
			{
				float4 vertex : SV_POSITION;
				float4 color : COLOR;
				float2 uv		: TEXCOORD0;
			};

			half4 _TintColor;
			float _Intensity;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			SamplerState sampler_MainTex;

			

			//버텍스 셰이더
			VertexOutput vert(VertexInput v)
			{
				VertexOutput o;
				o.vertex = TransformObjectToHClip(v.vertex.xyz);
				o.uv = v.uv.xy;
				//o.color = float4(v.color.x, v.color.y, v.color.z, _Intensity);
				return o;
			}

			//픽셀 셰이더
			half4 frag(VertexOutput i) : SV_Target
			{
				float2 uv = (i.uv.xy) * _MainTex_ST.xy + _MainTex_ST.zw;	//스케일 , 오프셋
				//float4 color = _MainTex.Sample(sampler_MainTex, uv) * _TintColor * _Intensity;
				float4 color = tex2D(_MainTex, uv) * _TintColor * _Intensity;
				//i.color = half4(0,0,0,1);				
				return color;// _TintColor* _Intensity;
			}
			ENDHLSL
		}
	}
}
