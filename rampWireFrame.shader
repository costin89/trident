Shader "TRIDENT/rampWireFrame"
{
    Properties
    {
        _LineColor("Line Color", Color) = (0, 0, 0, 1)
        _CheckerSize("Checker Size", Float) = 10.0
        _LineWidth("Line Width", Float) = 0.1
        _RampEdgeSoftness("Ramp Edge Softness", Float) = 0.5
        _RampType("Ramp Type (0=Radial, 1=Square)", Float) = 0.0
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha

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
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            fixed4 _LineColor;
            float _CheckerSize;
            float _LineWidth;
            float _RampEdgeSoftness;
            float _RampType;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float2 pos = i.uv * _CheckerSize;
                float2 cPos = frac(pos);

                // Linienlogik
                float edgeX = step(_LineWidth / _CheckerSize, abs(cPos.x - 0.5));
                float edgeY = step(_LineWidth / _CheckerSize, abs(cPos.y - 0.5));
                float edgeFactor = min(edgeX, edgeY);

                fixed4 color = edgeFactor < 1.0 ? _LineColor : fixed4(0, 0, 0, 0);

                // Rampenlogik
                float rampFactor;
                if (_RampType < 0.5)
                {
                    // Radiale Ramp
                    float distToCenter = length(i.uv - float2(0.5, 0.5));
                    rampFactor = 1.0 - smoothstep(0.5 - _RampEdgeSoftness, 0.5, distToCenter);
                }
                else
                {
                    // Eckige Ramp
                    float distToEdgeX = 0.5 - abs(i.uv.x - 0.5);
                    float distToEdgeY = 0.5 - abs(i.uv.y - 0.5);
                    float distToEdge = min(distToEdgeX, distToEdgeY);
                    rampFactor = smoothstep(0.0, _RampEdgeSoftness, distToEdge);
                }

                color.a *= rampFactor;

                return color;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}