Shader "Custom/depth"
{
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200

        CGPROGRAM

        #pragma surface surf Lambert noambint noshadow

        #pragma target 3.0

    sampler2D _CameraDepthTexture;

    struct Input
    {
        float4 screenPos;
    };

    UNITY_INSTANCING_BUFFER_START(Props)
        // put more per-instance properties here
    UNITY_INSTANCING_BUFFER_END(Props)

    void surf(Input IN, inout SurfaceOutput o)
    {
        float2 sPos = float2(IN.screenPos.x, IN.screenPos.y) / IN.screenPos.w;
        float4 Depth = tex2D(_CameraDepthTexture, sPos);

        o.Albedo = 0.3;
        o.Emission = Depth.r;
        o.Alpha = 0.0001;
    }
    ENDCG
    }
        FallBack off
}
