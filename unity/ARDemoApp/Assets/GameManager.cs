using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Newtonsoft.Json;
using PolyToolkit;
using PolyToolkitInternal;
using UnityEngine;
using UnityEngine.XR.ARFoundation;

public class GameManager : MonoBehaviour
{
    private ARRaycastManager _raycastManager;
    private ARCameraManager _cameraManager;
    //public GameObject Prefab;
    private List<ARRaycastHit> hits = new List<ARRaycastHit>();

    private PolyMainInternal _importer;
    

    public static string imageUrl =
        "https://upload.wikimedia.org/wikipedia/commons/thumb/4/42/The_ROCK.jpg/170px-The_ROCK.jpg";


    private void Awake()
    {
        UnityMessageManager.Instance.OnFlutterMessage+=OnFlutterMessage;
    }

    void Start()
    {
        _raycastManager = GetComponent<ARRaycastManager>();
        _cameraManager = GetComponentInChildren<ARCameraManager>();
        

        /*var asset = new PolyAsset()
        {
            name = "BoxTextured.gltf",
            formats =
            {
                new PolyFormat
                {
                    formatComplexity = new PolyFormatComplexity(), formatType = PolyFormatType.GLTF_2,
                    root = new PolyFile("cavallo", "cavallo", null), resources =
                    {
                        new PolyFile("BoxTextured0.bin","BoxTextured0.bin",null),
                        new PolyFile("CesiumLogoFlat.png","CesiumLogoFlat.png",null),
                    }
                }
            }
        };*/


    }

    private void OnFlutterMessage(MessageHandler handler)
    {
        Debug.Log("ON FLUTTER MESSAGE!");
        if (handler.name.Equals("PolyAsset"))
        {
            Debug.Log("IS POLY ASSET!");
            var data = handler.getData<String>();
            Debug.Log(data);
            var polyAsset = JsonConvert.DeserializeObject<PolyAsset>(data);
            Debug.Log("name:"+polyAsset.name);
            Debug.Log(polyAsset.ToString());
            PolyMainInternal.Instance.ImportFromLocal(polyAsset, new PolyImportOptions() {scaleFactor = 1}, PolyImportCallback);
        }
    }

    private void PolyImportCallback(PolyAsset asset, PolyStatusOr<PolyImportResult> result)
    {
        if (result.Ok)
        {
            Debug.Log("Import Completed!");
        }
        else
        {
            Debug.LogError(result.Status.errorMessage);
        }
    }


    public void SetURL(string url)
    {
        imageUrl = url;
    }

    private void OnApplicationFocus(bool hasFocus)
    {
        /*if (hasFocus)
        {
            AndroidJavaClass UnityPlayer = new AndroidJavaClass("com.unity3d.player.UnityPlayer"); 
 
            AndroidJavaObject currentActivity = UnityPlayer.GetStatic<AndroidJavaObject>("currentActivity");
 
            AndroidJavaObject intent = currentActivity.Call<AndroidJavaObject>("getIntent");
                  
            String text = intent.Call<String> ("getStringExtra", "URL");
        
            imageUrl = text;
        }*/
    }

    void Update()
    {
#if UNITY_EDITOR
        if (Input.GetKeyDown(KeyCode.A))
        {
            var spawnPoint = Vector3.zero;
            var cameraPos = _cameraManager.transform.position;
            var cameraHeight0Pos = new Vector3(cameraPos.x, spawnPoint.y, cameraPos.z);
            var direction = Quaternion.LookRotation(spawnPoint - cameraHeight0Pos);
            var asset = new PolyAsset()
            {
                name = "BoxTextured.gltf",
                formats =
                {
                    new PolyFormat
                    {
                        formatComplexity = new PolyFormatComplexity(), formatType = PolyFormatType.GLTF2,
                        root = new PolyFile("BoxTextured.gltf", "BoxTextured.gltf", null), resources =
                        {
                            new PolyFile("BoxTextured0.bin","BoxTextured0.bin",null),
                            new PolyFile("CesiumLogoFlat.png","CesiumLogoFlat.png",null),
                        }
                    }
                }
            };
            OnFlutterMessage(new MessageHandler(0,"","PolyAsset",JsonConvert.SerializeObject(asset)));
            //Instantiate(Prefab, spawnPoint, direction);
        }
#else
        if (Input.touchCount == 1 && Input.GetTouch(0).phase == TouchPhase.Began)
        {
            if (_raycastManager.Raycast(Input.GetTouch(0).position,hits))
            {
                var spawnPoint = hits.First().pose.position;
                var cameraPos = _cameraManager.transform.position;
                var cameraHeight0Pos = new Vector3(cameraPos.x,spawnPoint.y,cameraPos.z);
                var direction = Quaternion.LookRotation(spawnPoint - cameraHeight0Pos);
                //Instantiate(Prefab, spawnPoint, direction);
            }
        }
#endif
    }
}