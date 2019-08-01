using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SimulateWind : MonoBehaviour
{

    public Material material;

    public float UpdatePeriod;
    private float NextUpdateTime;

    [Range(0,1)]
    public float HorizontalMagnitude = .5f;
    public float WindFrequency;
    [Range(-.25f,.25f)]
    public float VerticalDirection;
    private Vector4 windWeights;
    

    // Start is called before the first frame update
    void Start()
    {
        NextUpdateTime = UpdatePeriod;
    }

    // Update is called once per frame
    void Update()
    {
        if(Time.time >= NextUpdateTime){

            UpdateWindValues();
            material.SetVector("_DiffusionWeights",windWeights);
            NextUpdateTime += UpdatePeriod;
        }
    }

    private void UpdateWindValues()
    {
        float xWinDir = ((Mathf.Sin(Time.time * WindFrequency)  * HorizontalMagnitude)  + 1)/2;
        windWeights[0] = Mathf.Lerp(0,.5f,xWinDir); 
        windWeights[2] = .5f - windWeights[0];
        
        //VerticalDirection
        windWeights[1] = .25f + VerticalDirection;
        windWeights[3] = .25f - VerticalDirection;

    }
}
