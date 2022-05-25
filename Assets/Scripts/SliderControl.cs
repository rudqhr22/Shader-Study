using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SliderControl : MonoBehaviour
{
    public MeshRenderer meshRenderer;

    private List<Slider> sliders;

    private void Awake()
    {
        sliders = new List<Slider>();
        foreach (Transform child in transform)
            sliders.Add(child.GetComponent<Slider>());            
    }

    void Start()
    {
        MaterialPropertyBlock mpb = new MaterialPropertyBlock();
        
        sliders[0].onValueChanged.AddListener((_v) => 
        {
           mpb.SetFloat("_WaveH", _v);
           meshRenderer.SetPropertyBlock(mpb);                
        });

        sliders[1].onValueChanged.AddListener((_v) => {
        mpb.SetFloat("_WaveL", _v);
            meshRenderer.SetPropertyBlock(mpb);
        });

        sliders[2].onValueChanged.AddListener((_v) => {
            mpb.SetFloat("_WaveT", _v);
            meshRenderer.SetPropertyBlock(mpb);
        });

        sliders[3].onValueChanged.AddListener((_v) => {
            mpb.SetFloat("_Refract", _v);
            meshRenderer.SetPropertyBlock(mpb);
        });
    }
}
