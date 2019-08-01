using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DrawToScreen : MonoBehaviour
{

    private Material Material;
    public RenderTexture DrawTexture;
    private RenderTexture Buffer;
    public Camera mainCamera;

    [Range(0,1)]
    public float DrawFrequency;
    private float NextDrawTime;

    public Color BrushColor = Color.white;

    [Range(.001f,.3f)]
    public float BrushRadius;
    private Vector4 BrushCenter; 

    // Start is called before the first frame update
    void Start()
    {
        this.Material = new Material(Shader.Find("Hidden/AddSmoke"));
        BrushCenter = new Vector4();
        if(!mainCamera)
            mainCamera = Camera.main;

        Buffer = new RenderTexture(DrawTexture.width,DrawTexture.height,DrawTexture.depth,DrawTexture.format);

            
    }




    private void Draw()
    {
        BrushCenter[0] = Input.mousePosition.x / mainCamera.pixelWidth;
        BrushCenter[1] = Input.mousePosition.y / mainCamera.pixelHeight;
        Material.SetFloat("_Radius", this.BrushRadius);
        Material.SetVector("_Center", BrushCenter);
        Material.SetColor("_SmokeColor", this.BrushColor);
        Graphics.Blit(DrawTexture, Buffer, Material);
        Graphics.Blit(Buffer,DrawTexture);
    }

    private bool lastMouseValue = false;
    void Update(){
        if(Input.GetMouseButton(0)){
            if(lastMouseValue && Time.time < this.NextDrawTime)
                return;
            Draw();
            lastMouseValue = true;
            this.NextDrawTime = Time.time + this.DrawFrequency;

        }
        else
        {
            lastMouseValue = false;
        }
    }
}
