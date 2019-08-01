using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]

public class CameraComparison : MonoBehaviour
{

    public RenderTexture OtherCameraRender;
    [Range(0,1)]
    public float BlendAmmount = .5f;
    private Material Material;

    // Start is called before the first frame update
    void Start()
    {
        
        Material = new Material(Shader.Find("Hidden/ComparisonMerge"));
    }

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        Material.SetTexture("_CompTex",OtherCameraRender);
        Material.SetFloat("_BlendAmmount",BlendAmmount);
        Graphics.Blit(src, dest, Material);
    }


}
