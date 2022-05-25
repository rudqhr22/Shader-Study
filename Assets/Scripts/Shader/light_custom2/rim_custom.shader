Shader "Custom/rim_custom"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap("Normal", 2D) = "Bump" {}
        _SpecCol("SpecColor", Color) = (1,1,1,1)
        _SpecPow("SpecPow", Range(0, 200)) = 100
        _GlossTex("GlossTex", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
            
        CGPROGRAM
        
        //#pragma surface surf Standard fullforwardshadows
        #pragma surface surf Test //noambient

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _BumpMap;
        sampler2D _GlossTex;

        float4 _SpecCol;
        float _SpecPow;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float2 uv_GlossTex;
        };

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {   
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            fixed4 m = tex2D(_GlossTex, IN.uv_GlossTex);

            o.Albedo = c.rgb;            
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            o.Alpha = c.a;
            o.Gloss = m.a;
        }

        float4 LightingTest(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
        {
            float4 final;

            //Lambert term
            float3 DiffColor;
            float ndot1 = saturate(dot(s.Normal, lightDir));
            DiffColor = ndot1 * s.Albedo * _LightColor0 * atten;

            //spec term
            float3 SpecColor;
            float3 H = normalize(lightDir + viewDir);
            float spec = saturate(dot(H, s.Normal));
            spec = pow(spec, _SpecPow);
            SpecColor = spec * _SpecCol.rgb * s.Gloss;

            //rim term
            float3 rimColor;
            float rim = abs(dot(viewDir, s.Normal));
            float invrim = 1 - rim;
            rimColor = pow(invrim, 6) * float3(0.5, 0.5, 0.5);

            //fake spec term
            float3 SpecColor2;
            SpecColor2 = pow(rim, 50) * float3(0.2, 0.2, 0.2) * s.Gloss;

            //final term
            final.rgb = SpecColor.rgb + DiffColor.rgb + rimColor.rgb + SpecColor2.rgb;
            final.a = s.Alpha;
            return final;// float4(SpecColor, 1);
        }

        ENDCG
    }
    FallBack "Diffuse"
}
