Shader "Custom/Dissolve"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _NoiseTex("Noise", 2D) = "white" {}
        _Cut("AlphaCut", Range(0,1)) = 0
        [HDR]_OutColor("OutColor", Color) = (1,1,1,1)
        _OutThinkness("OutThinkness", Range(1,1.5)) = 1.15
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        LOD 200

        CGPROGRAM        
        #pragma surface surf Lambert alpha:fade
        
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _NoiseTex;
        float _Cut;
        float4 _OutColor;
        float _OutThinkness;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NoiseTex;
        };


        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

            void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            //fixed4 noise = tex2D(_NoiseTex, ) IN.uv_NoiseTex);
            fixed4 noise = tex2D(_NoiseTex, IN.uv_NoiseTex);
            o.Albedo = c.rgb;

            float alpha;
            if (noise.r >= _Cut)
            {
                alpha = 1;
            }
            else
            {
                alpha = 0;
            }

            float outline;
            if (noise.r >= _Cut * _OutThinkness)
            {
                outline = 0;
            }
            else
            {
                outline = 1;
            }

            o.Emission = outline * _OutColor.rgb;
            o.Alpha = alpha;            
        }
        ENDCG
    }
    FallBack "Diffuse"
}
