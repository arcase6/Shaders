using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public struct AnimatorValue{
    public AnimatorParameter Parameter;
    public float Value;

    public void Set(Animator animator){
        switch(Parameter.ParameterType){
            case AnimationParameterType.Float:
                Parameter.SetFloat(animator, Value);
                break;
            case AnimationParameterType.Integer:
                Parameter.SetInt(animator, (int)Value);
                break;
            case AnimationParameterType.Bool:
                Parameter.SetBool(animator,Value != 0);
                break;
            case AnimationParameterType.Trigger:
                if(Value != 0)
                    Parameter.SetTrigger(animator);
                break;
        }
    }
}


public class InitAnimatorValues : MonoBehaviour, ISerializationCallbackReceiver
{

    public Animator Animator;
    public List<AnimatorValue> valuesToSet = new List<AnimatorValue>();

    private void Reset() {
        valuesToSet = new List<AnimatorValue>();
        Animator = GetComponent<Animator>();    
    }

    public void OnAfterDeserialize()
    {
        foreach (AnimatorValue value in valuesToSet)
        {
            value.Parameter.Init();
        }
    }

    public void OnBeforeSerialize()
    {

    }



    // Start is called before the first frame update
    void Start()
    {
        foreach (AnimatorValue value in valuesToSet)
        {
            value.Set(Animator);
        }
    }
}
