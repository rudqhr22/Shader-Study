Shader "Custom/holo"
{
    Properties
    {   
        _MainTex ("Albedo (RGB)", 2D) = "white" {}        
        _BumpMap("BumpMap", 2D) = "_BumpMap" {}        
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent"}
        LOD 200

        CGPROGRAM

        #pragma surface surf Lambert noambient alpha:fade

        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _BumpMap;
        

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;

            float3 viewDir;
            float3 worldPos;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {   
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            fixed4 d = tex2D(_BumpMap, IN.uv_MainTex);
            //o.Albedo = c.rgb;
            
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            o.Emission = float3(0, 1, 0);
            
            float rim = saturate(dot(o.Normal, IN.viewDir));
            rim = pow(1 - rim, 3) + pow(frac(IN.worldPos.g * 3 - _Time.y), 30);;
            //o.Emission = pow(1 - rim, 3);// _RimPower)* _RimColor.xyz;
            //o.Alpha = rim * (sin(_Time.y) * 0.5 + 0.5);
            //o.Alpha = rim * abs(sin(_Time.y * 3));
            o.Alpha = rim;
        }        

        ENDCG
    }
    FallBack "Diffuse"
}
