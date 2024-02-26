Shader "Unlit/VRFastSHADERFRONTBACK"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MatcapTexFront ("Front Matcap Texture", 2D) = "white" {}
        _MatcapTexBack ("Back Matcap Texture", 2D) = "white" {}
    }
    
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        
        Pass
        {
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
                float3 worldNormal : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
            };
            
            sampler2D _MainTex;
            sampler2D _MatcapTexFront;
            sampler2D _MatcapTexBack;
            float4 _MainTex_ST;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldNormal = mul((float3x3)UNITY_MATRIX_IT_MV, v.normal); // ①
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz; // ②
                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                float3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos)); // ③
                float3 worldNormal = normalize(i.worldNormal);
                float3 reflDir = reflect(-viewDir, worldNormal);
                float3 matCap = dot(viewDir, worldNormal) > 0.0 ? tex2D(_MatcapTexFront, reflDir.xy * 0.5 + 0.5).rgb : tex2D(_MatcapTexBack, reflDir.xy * 0.5 + 0.5).rgb; // ④
                fixed4 col = tex2D(_MainTex, i.uv);
                col.rgb = lerp(col.rgb, matCap, col.a); // ⑤
                return col;
            }
            ENDCG
        }
    }
}