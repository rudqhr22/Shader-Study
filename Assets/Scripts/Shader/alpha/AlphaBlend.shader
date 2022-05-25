Shader "Custom/AlphaBlend"
{
    Properties
    {

        _MainTex ("Albedo (RGB)", 2D) = "white" {}

    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        cull off
        
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Lambert alpha:fade

        
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };


        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {   
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Legacy Shaders/Transparent/VertexLit"
}
