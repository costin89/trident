Shader "TRIDENT/rampCheckerBoard"
{
    Properties
    {
        _Color1 ("Color 1", Color) = (1,0,0,1) // Rot
        _Color2 ("Color 2", Color) = (0,1,0,1) // Grün
        _FadeRadius("Fade Radius", Float) = 0.5
        _EdgeSharpness("Edge Sharpness", Float) = 10.0
        _CheckerScale("Checker Scale", Float) = 10.0
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
        LOD 100

        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off

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

            float4 _Color1;
            float4 _Color2;
            float _FadeRadius;
            float _EdgeSharpness;
            float _CheckerScale;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                // Schachbrettmuster Größe anpassen
                float checkerScale = _CheckerScale;
                bool isOdd = (int(floor(i.uv.x * checkerScale) + floor(i.uv.y * checkerScale)) % 2) == 0;
                float4 color = isOdd ? _Color1 : _Color2;

                // Kreisförmige Transparenz
                float2 center = float2(0.5, 0.5);
                float distance = length(i.uv - center);
                float alpha = smoothstep(_FadeRadius, _FadeRadius - (_FadeRadius / _EdgeSharpness), distance);

                color.a *= alpha;

                return color;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
