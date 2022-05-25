Shader "Custom/MatCap"
{
    Properties
    {   
        _MainTex ("Albedo (RGB)", 2D) = "white" {}        
        _MatCap("Matcap",2D) = "white"{}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        
        #pragma surface surf nolight noambient

        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _MatCap;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldNormal;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {   
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            //o.Albedo = c.rgb;
            float3 viewNormal = mul((float3x3)UNITY_MATRIX_V, IN.worldNormal.rgb);
            float2 MatCapUV = viewNormal.xy * 0.5 + 0.5;
            o.Emission = tex2D(_MatCap, MatCapUV) * c.rgb;
            o.Alpha = c.a;
        }

        float4 Lightingnolight(SurfaceOutput s, float3 lightDir, float atten) {
            return float4(0, 0, 0, s.Alpha);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
