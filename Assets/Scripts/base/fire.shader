Shader "Custom/fire"
{
    Properties
    {
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _MainTex2("Albedo (RGB)", 2D) = "black" {}        
    }
        SubShader
    {
        Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        //#pragma surface surf Standard fullforwardshadows
        #pragma surface surf Standard alpha:fade

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _MainTex2;
        

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_MainTex2;            
        };

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 d = tex2D(_MainTex2, float2(IN.uv_MainTex2.x, IN.uv_MainTex2.y - _Time.y));
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex + d.r);
            
            o.Emission = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
        FallBack "Diffuse"
}


//Shader "Custom/fire"
//{
//    Properties
//    {   
//        _MainTex ("Albedo (RGB)", 2D) = "white" {}        
//        _MainTex2("Albedo (RGB)", 2D) = "white" {}
//    }
//    SubShader
//    {
//        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
//        LOD 200
//
//        CGPROGRAM
//        // Physically based Standard lighting model, and enable shadows on all light types
//        //#pragma surface surf Standard fullforwardshadows
//        #pragma surface surf Standard alpha:fade
//
//        // Use shader model 3.0 target, to get nicer looking lighting
//        #pragma target 3.0
//
//        sampler2D _MainTex;
//        sampler2D _MainTex2;
//
//        struct Input
//        {
//            float2 uv_MainTex;
//            float2 uv_MainTex2;
//        };
//
//        void surf (Input IN, inout SurfaceOutputStandard o)
//        {
//            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
//            fixed4 d = tex2D(_MainTex2, float2(IN.uv_MainTex2.x, IN.uv_MainTex2.y - _Time.y));
//            o.Emission = c.rgb * d.rgb;            
//            o.Alpha = c.a * d.a;
//        }
//        ENDCG
//    }
//    FallBack "Diffuse"
//}
