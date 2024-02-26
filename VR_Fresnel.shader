Shader "Unlit/VR_Fresnel"
{
    Properties {
            _MainTex ("Texture", 2D) = "white" {}
            _MatcapTex ("MatcapTexture", 2D) = "white" {}
            _Color ("Color", Color) = (1, 1, 1, 1)
            _FresnelPower ("Fresnel Power", Range(0, 10)) = 3
            _FresnelBias ("Fresnel Bias", Range(-1, 1)) = 0.1
        }
        
        SubShader {
            Tags { "RenderType"="Opaque" }
            LOD 100
            
            Pass {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #include "UnityCG.cginc"
                
                struct appdata {
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
                    float2 uv : TEXCOORD0;
                };
                
                struct v2f {
                    float2 uv : TEXCOORD0;
                    float4 vertex : SV_POSITION;
                    float3 viewNormal : TEXCOORD1;
                };
                
                sampler2D _MainTex;
                sampler2D _MatcapTex;
                float4 _MainTex_ST;
                float4 _Color;
                float _FresnelPower;
                float _FresnelBias;
                
                v2f vert (appdata v) {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                    o.viewNormal = mul((float3x3)UNITY_MATRIX_V, UnityObjectToWorldNormal(v.normal));
                    return o;
                }
                
                fixed4 frag (v2f i) : SV_Target {
                    float3 matCap = tex2D(_MatcapTex, i.viewNormal.xy * 0.5 + 0.5).rgb;
                    float fresnel = pow(1 - dot(normalize(i.viewNormal), normalize(_WorldSpaceCameraPos.xyz)), _FresnelPower);
                    fresnel = saturate(fresnel + _FresnelBias);
                    return tex2D(_MainTex, i.uv) * (matCap * fresnel * _Color);
                }
                ENDCG
            }
        }
}
