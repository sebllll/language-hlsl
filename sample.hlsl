#ifndef HELLO_WORLD
#define HELLO_WORLD vec3(0.0, 0.0, 0.0)
#else
#define LOREM_IPSUM
#endif

#pragma GENERIC_PRAGMA

#pragma glslify: noise = require(glsl-noise)
#pragma glslify: random = require(glsl-random)
#pragma glslify: export(x)

void main() {
  float3 a = noise(gl_FragColor.xy);
  float3 b = y.xyz;

  a.xyz = gl_FragColor.xyz;
}


//@author: vux
//@help: standard constant shader
//@tags: color
//@credits:

Texture2D texture2d <string uiname="Texture";>;

SamplerState g_samLinear <string uiname="Sampler State";>
{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU = Clamp;
    AddressV = Clamp;
};


cbuffer cbPerDraw : register( b0 )
{
	float4x4 tVP : VIEWPROJECTION;
};


cbuffer cbPerObj : register( b1 )
{
	float4x4 tW : WORLD;
	float Alpha <float uimin=0.0; float uimax=1.0;> = 1;
	float4 cAmb <bool color=true;String uiname="Color";> = { 1.0f,1.0f,1.0f,1.0f };
	float4x4 tTex <string uiname="Texture Transform"; bool uvspace=true; >;
	float4x4 tColor <string uiname="Color Transform";>;
};

struct VS_IN
{
	float4 PosO : POSITION;
	float4 TexCd : TEXCOORD0;

};

struct vs2ps
{
    float4 PosWVP: SV_POSITION;
    float4 TexCd: TEXCOORD0;
};

vs2ps VS(VS_IN input)
{
    vs2ps Out = (vs2ps)0;
    Out.PosWVP  = mul(input.PosO,mul(tW,tVP));
    Out.TexCd = mul(input.TexCd, tTex);
    return Out;
}




float4 PS(vs2ps In): SV_Target
{
    float4 col = texture2d.Sample(g_samLinear,In.TexCd.xy) * cAmb;
	col = mul(col, tColor);
	col.a *= Alpha;
    return col;
}





technique10 Constant
{
	pass P0
	{
		SetVertexShader( CompileShader( vs_4_0, VS() ) );
		SetPixelShader( CompileShader( ps_4_0, PS() ) );
	}
}
