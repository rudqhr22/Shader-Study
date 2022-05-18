Shader "Custom/Custom_Light"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap("Normal", 2D) = "Bump" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
            
        CGPROGRAM
        
        //#pragma surface surf Standard fullforwardshadows
        #pragma surface surf Test noambient

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _BumpMap;
        

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
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
            o.Albedo = c.rgb;            
            o.Alpha = c.a;
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
        }

        float4 LightingTest(SurfaceOutput s, float3 lightDir, float atten)
        {
            float ndot1 = saturate(dot(s.Normal, lightDir));    //sautrate  0 lower cut
            //float ndot1 = max(0, (dot(s.Normal, lightDir)));      //greater value
            return ndot1;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
