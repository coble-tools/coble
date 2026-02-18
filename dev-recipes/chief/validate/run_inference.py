image = Image.open("./exsample/exsample.tif")
image = trnsfrms_val(image).unsqueeze(dim=0)
with torch.no_grad():
    patch_feature_emb = model(image) # Extracted features (torch.Tensor) with shape [1,768]
    print(patch_feature_emb.size())
