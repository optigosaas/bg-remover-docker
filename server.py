from fastapi import FastAPI, UploadFile, File
from fastapi.responses import Response
from rembg import remove

app = FastAPI()

@app.post("/remove")
async def remove_bg(file: UploadFile = File(...)):
    data = await file.read()
    result = remove(data)
    return Response(content=result, media_type="image/png")
