Shader "StencilBuffer/IncrementMask"
{
    Properties
    {
        _StencilIncAmount("Stencil Inc Amount", Int) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue" = "Geometry-100" }
        LOD 100
        
        //do not write to any channels -- ColorMask is a command to limit writing to single channels
        ColorMask 0
        
        //do not write to z buffer since see-through
        ZWrite off

        // stencil buffer reference https://docs.unity3d.com/Manual/SL-Stencil.html
        Stencil{

            //this is the value to be used in the comparison function
            //and/ or the new value to be written to the stencil buffer
            Ref[_StencilIncAmount]

            //Comp - what function to use for comparison - return true no matter once in case of always
            Comp always
            //What to do if comp is true - increment the buffer by 1
            Pass IncrSat
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                return fixed4(1,1,0,1); //write yellow (not actually written because of color mask)
                
            }
            ENDCG
        }
    }
}
