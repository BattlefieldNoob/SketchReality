using System;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using TMPro;
using UnityEngine;

public class CameraControl : MonoBehaviour
{
    private Vector3 sphericalCenter = Vector3.zero;

    private float radius = 1;

    private Vector2 sphericalAngles = Vector2.zero;

    private Transform rotator;

    public float speed = 10;
    public float ScrollSpeed = 10;
    public float inertialMultiplier = 2;

#if UNITY_EDITOR
    private Vector2 latestViewportXY;
    private Vector2 currentViewportXY;
#endif

    private Vector2 swipeDelta;
    private Vector2 zoomDelta;
    
    private readonly Vector2 reductionScale=new Vector2(0.9f,0.9f);

    private float referenceDistance = 0;
    private Camera _camera;

    private void Awake()
    {
        enabled = false;
    }

    void Start()
    {
        Debug.Log("Camera Control start");
        _camera = GetComponent<Camera>();
        rotator = transform.parent;
    }

    void Update()
    {
#if UNITY_EDITOR
        if (Input.GetMouseButton(0))
#else
            if(Input.touchCount==1)
#endif
        {
            //Debug.Log("Update camera");
            swipeDelta = GetScreenSwipeDelta();
            ApplySwipeDelta();
            //Debug.Log("camera rotation:"+rotator.eulerAngles);
        }
        else
        {
            if (Math.Abs(swipeDelta.magnitude)*inertialMultiplier > 0.01f)
            {
                Debug.Log(swipeDelta.magnitude);
                //riduco gradualmente lo swipeDelta finchè non raggiunge lo zero
                swipeDelta.Scale(reductionScale);
                ApplySwipeDelta();
            }
        }
#if UNITY_EDITOR
        radius += Input.mouseScrollDelta.y * Time.deltaTime * (ScrollSpeed/10);
#else
         if (Input.touchCount == 2)
        {
            var touch0 = Input.GetTouch(0);
            var touch1 = Input.GetTouch(1);
            
            var distance = Vector2.Distance( GetXYPositionScreenNormalized(touch0.position), GetXYPositionScreenNormalized(touch1.position));

            if (touch0.phase != TouchPhase.Began && touch1.phase != TouchPhase.Began)
            {
                //Debug.Log("Distance "+distance);
                radius += (1-(distance / referenceDistance)) * Time.deltaTime * ScrollSpeed;
                //Debug.Log("Radius "+radius);
            }
            referenceDistance = distance;
        }
#endif
        radius = Mathf.Clamp(radius, 0.65f, 4f);
        transform.localPosition=new Vector3(0,0,radius);
        //Debug.Log("camera position:"+transform.localPosition);
        transform.LookAt(sphericalCenter);
        //Debug.Log("camera lookat rotation:"+transform.eulerAngles);
    }

    private void ApplySwipeDelta()
    {
        var theta = sphericalAngles.x + (swipeDelta.x * Time.deltaTime * speed);
        var phi = sphericalAngles.y + (swipeDelta.y * Time.deltaTime * speed);
        sphericalAngles.Set(theta, phi);
        rotator.rotation =
            Quaternion.Euler(Mathf.Rad2Deg * sphericalAngles.y, Mathf.Rad2Deg * sphericalAngles.x, 0);
    }


    private Vector2 GetScreenSwipeDelta()
    {
#if !UNITY_EDITOR
        return GetXYPositionScreenNormalized(Input.GetTouch(0).deltaPosition);
#else
        var normalized = GetXYPositionScreenNormalized(Input.mousePosition);

        if (Input.GetMouseButtonDown(0))
        {
            latestViewportXY.Set(normalized.x, normalized.y);
            return Vector2.zero;
        }

        currentViewportXY.Set(normalized.x, normalized.y);
        var delta = currentViewportXY - latestViewportXY;
        latestViewportXY.Set(currentViewportXY.x, currentViewportXY.y);
        return delta;
#endif
    }

    private Vector2 GetXYPositionScreenNormalized(Vector3 position) =>
        _camera.ScreenToViewportPoint(position);
}