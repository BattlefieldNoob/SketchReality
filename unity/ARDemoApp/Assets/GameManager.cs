using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Newtonsoft.Json;
using PolyToolkit;
using PolyToolkitInternal;
using UnityEngine;
using UnityEngine.SpatialTracking;
using UnityEngine.XR;
using UnityEngine.XR.ARFoundation;

public class GameManager : MonoBehaviour
{
    private ARSession _session;
    private ARCameraManager _cameraManager;
    //public GameObject Prefab;
#if !UNITY_EDITOR
    private ARRaycastManager _raycastManager;
    private List<ARRaycastHit> hits = new List<ARRaycastHit>();
#endif

    private PolyMainInternal _importer;

    private PolyAsset _assetToLoad;

    private void Awake()
    {
        UnityMessageManager.Instance.OnFlutterMessage += OnFlutterMessage;
        _session = FindObjectOfType<ARSession>();
        _session.enabled = false;
    }

    IEnumerator Start()
    {
#if !UNITY_EDITOR
        _raycastManager = GetComponent<ARRaycastManager>();
#endif
        _cameraManager = GetComponentInChildren<ARCameraManager>();

        yield return ARSession.CheckAvailability();

        Debug.Log(ARSession.state);
        switch (ARSession.state)
        {
            case ARSessionState.Unsupported:
            case ARSessionState.NeedsInstall:
                InitializeWithoutAR();
                break;
            default:
                InitializeWithAR();
                break;
        }
    }

    private void InitializeWithAR()
    {
        throw new NotImplementedException();
    }

    private void InitializeWithoutAR()
    {
        var background = _cameraManager.GetComponent<ARCameraBackground>();
        background.enabled = false;
        var trackedPose = _cameraManager.GetComponent<TrackedPoseDriver>();
        trackedPose.enabled = false;
        var camera = _cameraManager.GetComponent<Camera>();
        camera.clearFlags = CameraClearFlags.SolidColor;
        camera.backgroundColor = Color.gray;
        var cameraControl = camera.GetComponent<CameraControl>();

#if UNITY_EDITOR || DEVELOPMENT_BUILD
        if (_assetToLoad == null)
        {
            var asset = new PolyAsset()
            {
                name = "assets/EditorTest",
                formats =
                {
                    new PolyFormat
                    {
                        formatComplexity = new PolyFormatComplexity(), formatType = PolyFormatType.GLTF2,
                        root = new PolyFile("BoxTextured.gltf", "BoxTextured.gltf", null), resources =
                        {
                            new PolyFile("BoxTextured0.bin", "BoxTextured0.bin", null),
                            new PolyFile("CesiumLogoFlat.png", "CesiumLogoFlat.png", null),
                        }
                    }
                }
            };
            OnFlutterMessage(new MessageHandler(0, "", "PolyAsset", JsonConvert.SerializeObject(asset)));
        }
#endif

        if (_assetToLoad != null)
        {
            Debug.Log("name:" + _assetToLoad.name);
            Debug.Log(_assetToLoad.ToString());
            PolyMainInternal.Instance.ImportFromLocal(_assetToLoad, new PolyImportOptions() {scaleFactor = 1},
                (loadedasset, result) =>
                {
                    if (result.Ok)
                    {
                        cameraControl.enabled = true;
                    }
                });
        }
    }

    private void OnFlutterMessage(MessageHandler handler)
    {
        Debug.Log("ON FLUTTER MESSAGE!");
        if (handler.name.Equals("PolyAsset"))
        {
            Debug.Log("IS POLY ASSET!");
            var data = handler.getData<String>();
            Debug.Log(data);
            _assetToLoad = JsonConvert.DeserializeObject<PolyAsset>(data);
        }
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
                name = "assets/EditorTest",
                formats =
                {
                    new PolyFormat
                    {
                        formatComplexity = new PolyFormatComplexity(), formatType = PolyFormatType.GLTF2,
                        root = new PolyFile("BoxTextured.gltf", "BoxTextured.gltf", null), resources =
                        {
                            new PolyFile("BoxTextured0.bin", "BoxTextured0.bin", null),
                            new PolyFile("CesiumLogoFlat.png", "CesiumLogoFlat.png", null),
                        }
                    }
                }
            };
            OnFlutterMessage(new MessageHandler(0, "", "PolyAsset", JsonConvert.SerializeObject(asset)));
            //Instantiate(Prefab, spawnPoint, direction);
        }
#else
        /*if (Input.touchCount == 1 && Input.GetTouch(0).phase == TouchPhase.Began)
        {
            if (_raycastManager.Raycast(Input.GetTouch(0).position,hits))
            {
                var spawnPoint = hits.First().pose.position;
                var cameraPos = _cameraManager.transform.position;
                var cameraHeight0Pos = new Vector3(cameraPos.x,spawnPoint.y,cameraPos.z);
                var direction = Quaternion.LookRotation(spawnPoint - cameraHeight0Pos);
                //Instantiate(Prefab, spawnPoint, direction);
            }
        }*/
#endif
    }
}