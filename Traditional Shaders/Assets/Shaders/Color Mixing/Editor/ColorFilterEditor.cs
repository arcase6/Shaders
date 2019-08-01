using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(ColorFilter))]
public class ColorFilterEditor : Editor {

    SerializedProperty ModeP;

    [ExecuteInEditMode]
    private void OnEnable(){
        ModeP = this.serializedObject.FindProperty("mode");

    }
    public override void OnInspectorGUI() {
        base.OnInspectorGUI();

        EditorGUI.BeginChangeCheck();
        EditorGUILayout.PropertyField(ModeP);
        if(EditorGUI.EndChangeCheck()){
            serializedObject.ApplyModifiedProperties();
            ((ColorFilter)target).UpdateShader();
        }
    }
}