//1pass Fresnel 방법

Shader "Custom/toon_Fresnel"
{

    Properties
    {
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _BumpMap("_BumpMap", 2D) = "Bump" {}
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }

        CGPROGRAM
        #pragma surface surf Toon //noambient

        sampler2D _MainTex;
        sampler2D _BumpMap;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);                

            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

        float4 LightingToon(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
        {
            float ndot1 = dot(s.Normal, lightDir) * 0.5 + 0.5;

            ndot1 = ndot1 * 5;
            ndot1 = ceil(ndot1) / 5;

            //if (ndot1 > 0.7)
            //    ndot1 = 1;
            //else if (ndot1 > 0.4)
            //    ndot1 = 0.3;
            //else 
            //    ndot1 = 0;

            float rim = abs(dot(s.Normal, viewDir));

            if (rim > 0.3)
                rim = 1;            
            else 
                rim = -1;
            

            float4 final;
            final.xyz = s.Albedo * ndot1 * _LightColor0.rgb * rim;
            final.a = s.Alpha;

            return final;
        }

        ENDCG
    }
        FallBack "Diffuse"
}
