Shader "TRIDENT/UnlitCheckerBoard"
{
    Properties
    {
        _Color1("Color 1", Color) = (1,1,1,1)
        _Color2("Color 2", Color) = (0,0,0,1)
        _CheckerSize("Checker Size", Float) = 10.0
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
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            fixed4 _Color1;
            fixed4 _Color2;
            float _CheckerSize;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 checker = floor(i.uv * _CheckerSize);
                float checkerPattern = fmod(checker.x + checker.y, 2.0);
                return lerp(_Color1, _Color2, checkerPattern);
            }
            ENDCG
        }
    }
}
