Shader "Custom/water"
{
    Properties
    {   
        _BumpTex("Normal", 2D) = "Bump" {}
        _Cube("Cube", Cube) = "" {}
        _SPColor("Specular Color", color) = (1,1,1,1)
        _SPPower("Specular Power", Range(50,300)) = 150
        _SPMulti("Specular Multiply",Range(1,10)) = 3
        _WaveH("Wave Height", Range(0,0.5)) = 0.1
        _WaveL("Wave Length", Range(5,20)) = 12
        _WaveT("Wave Timeing", Range(0,10)) = 1
        _Refract("Refract Strength" , Range(0,0.2)) = 0.1

    }
    
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf WaterSpecular vertex:vert

        #pragma target 3.0

        samplerCUBE _Cube;
        sampler2D _BumpTex;
        sampler2D _GrabTexture;
        float4 _SPColor;
        float _SPPower;
        float _SPMulti;
        float _WaveH;
        float _WaveL;
        float _WaveT;
        float _Refract;

        void vert(inout appdata_full v) {
            float movement;
            movement = sin(abs((v.texcoord.x * 2 - 1) * _WaveL) + _Time.y * _WaveT) * _WaveH;
            movement += sin(abs((v.texcoord.y * 2 - 1) * _WaveL) + _Time.y * _WaveT) * _WaveH;
            v.vertex.y += movement / 2;
        }

        struct Input {
            float2 uv_BumpTex;
            float3 worldRefl;
            float3 viewDir;
            float4 screenPos;
            INTERNAL_DATA
        };


        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {   
            float3 normal1 = UnpackNormal(tex2D(_BumpTex, IN.uv_BumpTex + _Time.x * 0.1));
            float3 normal2 = UnpackNormal(tex2D(_BumpTex, IN.uv_BumpTex - _Time.x * 0.1));

            o.Normal = (normal1 + normal2) / 2;
            float3 refcolor = texCUBE(_Cube, WorldReflectionVector(IN, o.Normal * _Time.y));
            
            //refraction 
            float3 screenUV = IN.screenPos.rgb / IN.screenPos.a;
            float3 refraction = tex2D(_GrabTexture, (screenUV.xy + o.Normal.xy * _Refract));

            //rim
            float rim = saturate(dot(o.Normal, IN.viewDir));
            rim = pow(1 - rim, 1.5);

            o.Emission = (refcolor * rim + refraction) * 0.5;
            o.Alpha = saturate(rim + 0.5);
        }

        float4 LightingWaterSpecular(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten) {

            //specular
            float3 H = normalize(lightDir + viewDir);
            float spec = saturate(dot(H, s.Normal));
            spec = pow(spec, _SPPower);

            //final
            float4 finalColor;
            finalColor.rgb = spec * _SPColor.rgb * _SPMulti;
            finalColor.a = s.Alpha;

            return finalColor;
        }
        ENDCG
    }
    FallBack "Regacy Shaders/Transparent/Vertexlit"
}
