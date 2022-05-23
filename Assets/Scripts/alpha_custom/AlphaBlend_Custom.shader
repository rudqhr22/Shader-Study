Shader "Custom/AlphaBlend_Custom"
{
    Properties
    {
        _Tint("Tint Color", COlor) = (0.5,0.5,0.5)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}

    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" "IgnoreProjector"="True"}

        zwrite off
        blend SrcAlpha OneMinusSrcAlpha
        
        LOD 200

        CGPROGRAM
        
        #pragma surface surf Lambert keepalha noforwardadd nolightmap noambient novertexlights noshadow
        
        #pragma target 3.0

        sampler2D _MainTex;
        float4 _TintColor;

        struct Input
        {
            float2 uv_MainTex;
            float4 color:COLOR;
        };


        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {   
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            c = c * 2 * +_TintColor * IN.color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

        float Lightingnolight(SurfaceOutput s, float3 lightDIr, float atten)
        {
            return float4(0,0,0,s.Alpha);
        }

        ENDCG
    }
    FallBack "Legacy Shaders/Transparent/VertexLit"
}
