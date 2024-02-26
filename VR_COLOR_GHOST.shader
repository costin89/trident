Shader "Unlit/VRColorGhost"
{
    Properties
    {
        _MainColor ("Main Color", Color) = (1,1,1,1)
        _MatcapTex1 ("MatcapTexture 1", 2D) = "white" {}
        _MatcapTex2 ("MatcapTexture 2", 2D) = "white" {}
        _GhostIntensity("Ghost Intensity", Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
    
        Pass
        {
            Blend One One
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
        
            #include "UnityCG.cginc"
        
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };
        
            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 viewNormal : TEXCOORD1; 
            };
        
            float4 _MainColor;
            sampler2D _MatcapTex1;
            sampler2D _MatcapTex2;
            float _GhostIntensity;
        
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.viewNormal = mul((float3x3)UNITY_MATRIX_V, UnityObjectToWorldNormal(v.normal));
                return o;
            }
        
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = _MainColor;
                float3 matCap1 = tex2D(_MatcapTex1, i.viewNormal.xy * 0.5 + 0.5).rgb;
                float3 matCap2 = tex2D(_MatcapTex2, i.viewNormal.xy * 0.5 + 0.5).rgb;
                float3 matCap = matCap1 * matCap2;
                matCap *= _GhostIntensity;
                col.rgb += matCap;
                return col;
            }
            ENDCG
        }
    }   
}
