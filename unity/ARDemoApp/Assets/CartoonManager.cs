using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;

public class CartoonManager : MonoBehaviour
{
    private Material CartoonMaterial;
    private Renderer _renderer;
    
    void Start()
    {
        _renderer = GetComponentInChildren<MeshRenderer>();
        CartoonMaterial = _renderer.material;
        StartCoroutine(LoadImage());
    }

    private void OnApplicationFocus(bool hasFocus)
    {
        if (hasFocus)
        {
            StartCoroutine(LoadImage());
        }
        else
        {
            _renderer.enabled = false;
        }
    }

    private IEnumerator LoadImage()
    {
        yield return null;
        UnityWebRequestTexture.GetTexture(GameManager.imageUrl).SendWebRequest().completed += OnDownloadCompleted;
    }

    private void OnDownloadCompleted(AsyncOperation operation)
    {
        var webOperation = operation as UnityWebRequestAsyncOperation;
        if (webOperation != null)
        {
            var texturehandle = webOperation.webRequest.downloadHandler as DownloadHandlerTexture;
            if (texturehandle != null) CartoonMaterial.mainTexture = texturehandle.texture;
            _renderer.enabled = true;
        }
    }
    
    
}
