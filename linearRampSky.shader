Shader "TRIDENT/linearRampSky"
{
    Properties {
        _TopColor ("Top Color", Color) = (0.0,0.5,1,1)
        _BottomColor ("Bottom Color", Color) = (0.01,0.01,0.01,1)
        _GradientControl ("Gradient Control", Range(0,1)) = 0.5
    }
    SubShader {
        Tags { "Queue"="Background" }
        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            fixed4 _TopColor;
            fixed4 _BottomColor;
            float _GradientControl;

            struct appdata {
                float4 vertex : POSITION;
            };

            struct v2f {
                float3 pos : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v) {
                v2f o;
                o.pos = v.vertex.xyz;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target {
                float t = (i.pos.y + 1.0) * 0.5;
                t = pow(t, _GradientControl * 2.0 + 1.0); // Anpassen der Verteilung basierend auf _GradientControl
                return lerp(_BottomColor, _TopColor, t);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}