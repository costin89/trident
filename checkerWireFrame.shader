Shader "TRIDENT/checkerWireFrame"
{
    Properties
    {
        _Color1("Checker Color 1", Color) = (1, 0, 0, 1)
        _Color2("Checker Color 2", Color) = (0, 1, 0, 1)
        _LineColor("Line Color", Color) = (0, 0, 0, 1)
        _CheckerSize("Checker Size", Float) = 10.0
        _LineWidth("Line Width", Float) = 0.1
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

            fixed4 _Color1;
            fixed4 _Color2;
            fixed4 _LineColor;
            float _CheckerSize;
            float _LineWidth;

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
                bool isCheckerX = step(0.5, cPos.x) > 0.0;
                bool isCheckerY = step(0.5, cPos.y) > 0.0;
                bool isChecker1 = (isCheckerX && isCheckerY) || (!isCheckerX && !isCheckerY);

                fixed4 color = isChecker1 ? _Color1 : _Color2;

                // Berechne den Abstand zum Zentrum jedes Quadrats
                float2 distToCenter = abs(cPos - 0.5);
                // Bestimme, ob die Pixel innerhalb der Linienbreite liegen
                float edgeX = step(_LineWidth / _CheckerSize, distToCenter.x);
                float edgeY = step(_LineWidth / _CheckerSize, distToCenter.y);
                float edgeFactor = min(edgeX, edgeY);

                // Mische Linienfarbe basierend auf dem edgeFactor
                color = edgeFactor < 1.0 ? _LineColor : color;

                return color;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
