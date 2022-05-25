//2pass 방법

Shader "Custom/toon1"
{

    Properties
    {
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _BumpMap("_BumpMap", 2D) = "Bump" {}
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }

        cull front

        CGPROGRAM        
        #pragma surface surf Nolight vertex:vert noshadow noambient
        
        struct Input
        {
            float4 color:COLOR;
        };

        void vert(inout appdata_full v)
        {
            //v.vertex.y = v.vertex.y + 1;
            v.vertex.xyz = v.vertex.xyz + v.vertex.xyz * 0.01;
        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            
        }

        float4 LightingNolight(SurfaceOutput s, float3 lightDir, float atten)
        {
            return float4(0, 0, 0, 1);
        }

        ENDCG

        //2pass
        cull back
        CGPROGRAM
        #pragma surface surf Toon noambient

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

        float4 LightingToon(SurfaceOutput s, float3 lightDir, float atten)
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

            float4 final;
            final.xyz = s.Albedo * ndot1 * _LightColor0.rgb;
            final.a = s.Alpha;

            return final;
        }

        ENDCG
    }
        FallBack "Diffuse"
}
