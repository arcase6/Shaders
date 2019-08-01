using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class OverlayImage : MonoBehaviour
{
    private Material Material;
    public Texture Image;
    [Range(0,1)]
    public float ImageAlpha = 1;

    // Start is called before the first frame update
    void Awake()
    {
        Material = new Material(Shader.Find("Hidden/OverlayCamera"));
    }

    void OnRenderImage(RenderTexture src, RenderTexture dest) {
        if(ImageAlpha == 0){
            Graphics.Blit(src,dest);
            return;
        }

        Material.SetTexture("_OverlayImage",Image);
        Material.SetFloat("_OverlayAlpha",ImageAlpha);
        Graphics.Blit(src,dest,Material);
    }
}
