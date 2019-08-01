using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TextureProcessor : MonoBehaviour
{

    public Texture InitialTexture;
    public Material material;
    
    public RenderTexture texture;
    public float updateInterval = 0.1f; //Seconds
    private RenderTexture buffer;
    
    
    private float nextUpdateTime = 0;
    
    // Start is called before the first frame update
    void Start()
    {
        Graphics.Blit(InitialTexture,texture);
        buffer = new RenderTexture(texture.width,texture.height,texture.depth,texture.format);
        nextUpdateTime = 0;
    }

    

    // Update is called once per frame
    void Update()
    {
        if(Time.time > nextUpdateTime){
            UpdateTexture();
            nextUpdateTime = Time.time + updateInterval;
        }
    }

    private void UpdateTexture()
    {
        Graphics.Blit(texture,buffer,material);
        Graphics.Blit(buffer,texture);
    }
}
