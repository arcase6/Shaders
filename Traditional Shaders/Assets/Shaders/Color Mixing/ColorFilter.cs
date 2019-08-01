using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public enum ColorFilterMode
{
    Normal,
    Protanopia,
    Protanomaly,
    Deuteranopia,
    Deuteranomaly,
    Tritanopia,
    Tritanomaly,
    Achromatopsia,
    Achromatomaly
}


[ExecuteInEditMode]
public class ColorFilter : MonoBehaviour
{
    public static List<Color[]> ColorModeLookup;

    static ColorFilter()
    {
        ColorModeLookup = new List<Color[]>();
        ColorModeLookup.Add(new Color[] { new Color(1, 0, 0), new Color(0, 1, 0), new Color(0, 0, 1) });    //Normal
        ColorModeLookup.Add(new Color[] { new Color(.566667f, .433333f, 0), new Color(.55833f, .44167f, 0), new Color(0, .24167f, .75833f) }); //Protanopia
        ColorModeLookup.Add(new Color[] { new Color(.81667f, .18333f, 0), new Color(.33333f, .66667f,0f), new Color(0, .125f, .875f) }); //Protanomaly

        ColorModeLookup.Add(new Color[] { new Color(.625f, .375f, 0), new Color(.7f, .3f,0), new Color(0, .3f, .7f) }); //Deuteranopia
        ColorModeLookup.Add(new Color[] { new Color(.8f, .2f, 0), new Color(0, .25833f, .74167f), new Color(0, .14167f, .85833f) }); //Deuteranomaly
        ColorModeLookup.Add(new Color[] { new Color(.95f, .5f, 0), new Color(0, .43333f, .56667f), new Color(0, .475f, .525f) }); //Tritanopia

        ColorModeLookup.Add(new Color[] { new Color(.96667f, .033333f, 0), new Color(0, .733333f, .26667f), new Color(0, .18333f, .81667f) }); //Tritanomaly
        ColorModeLookup.Add(new Color[] { new Color(.299f, .587f, .114f), new Color(.299f, .587f, .114f), new Color(.299f, .587f, .114f) }); //Achromatopsia
        ColorModeLookup.Add(new Color[] { new Color(.618f, .32f, .062f), new Color(.163f, .775f, .062f), new Color(.163f, .32f, .516f) }); //Achromatomaly
    }

    [SerializeField]
    [HideInInspector]
    private ColorFilterMode mode;
    public ColorFilterMode Mode
    {
        get => mode;
        set
        {
            mode = value;
            UpdateShader();
        }
    }


    private Color[] colors;
    private Material Material;

    // Start is called before the first frame update
    void Start()
    {
        this.Material = new Material(Shader.Find("Hidden/ColorMixer"));
        UpdateShader();
    }

    public void UpdateShader()
    {
        colors = ColorModeLookup[(int)this.mode];
        if (this.Material != null)
        {
            this.Material.SetColor("_R", colors[0]);
            this.Material.SetColor("_G", colors[1]);
            this.Material.SetColor("_B", colors[2]);
        }
    }

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        Graphics.Blit(src, dest, Material);
    }
}
