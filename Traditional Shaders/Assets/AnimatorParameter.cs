using UnityEngine;

[System.Serializable]
public enum AnimationParameterType{
    Integer,
    Float,
    Bool,
    Trigger
}

[System.Serializable]
public class AnimatorParameter{
    public string ParameterName;
    public int ParameterId;
    public AnimationParameterType ParameterType;
    public void SetValue(Animator animator, object value){
        switch(ParameterType){
            case AnimationParameterType.Integer:
                animator.SetInteger(ParameterId,(int)value);
                break;
            case AnimationParameterType.Float:
                animator.SetFloat(ParameterId,(float)value);
                break;
            case AnimationParameterType.Bool:
                animator.SetBool(ParameterId,(bool)value);
                break;
            case AnimationParameterType.Trigger:
                animator.SetTrigger(ParameterId);
                break;
        }
    }

    public void Init(){
        ParameterId = Animator.StringToHash(ParameterName);
    }

    public void SetInt(Animator animator, int value){
        animator.SetInteger(ParameterId,value);
    }
    
    public void SetFloat(Animator animator, float value){
        animator.SetFloat(ParameterId,value);
    }
    
    public void SetBool(Animator animator, bool value){
        animator.SetBool(ParameterId,value);
    }

    public void SetTrigger(Animator animator){
        animator.SetTrigger(ParameterId);
    }

    public float GetValueFloat(Animator animator){
        return animator.GetFloat(ParameterId);
    }

    public bool GetValueBool(Animator animator){
        return animator.GetBool(ParameterId);
    }

    public int GetValueInt(Animator animator){
        return animator.GetInteger(ParameterId);
    }
}
