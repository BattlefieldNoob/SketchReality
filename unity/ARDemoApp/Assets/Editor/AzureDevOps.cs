using UnityEditor;

public class AzureDevOps
{

    [MenuItem("Flutter/Android from Azure")]
    public static void PerformAndroidBuild()
    {
        Build.DoBuildAndroidLibrary();
        EditorApplication.Exit(0);
    }
}