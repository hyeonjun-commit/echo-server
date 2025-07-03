from typing import Any, Dict, Optional

import os
from fastapi import FastAPI, Request, status
from fastapi.responses import JSONResponse
import secrets, socket

app = FastAPI(title="Echo & Instance-Info API")

INSTANCE_CODE = secrets.token_hex(6)  # 12-자리 16진수(48비트 난수)

# 1) 단순 에코
@app.post("/echo", summary="받은 JSON 그대로 반환")
async def echo(payload: Dict[str, Any]):
    return payload
  
# 2) ping 
@app.get("/ping", summary="ping 명령")
async def healthz():
    return JSONResponse({"message": "pong",}, status_code=status.HTTP_200_OK)

# 3) info 서버 식별 정보 반환 
@app.get("/info", summary="서버 정보 반환")
async def healthz():
    return JSONResponse({
      "hostname": socket.gethostname(),
      "identity code": INSTANCE_CODE,
    }, status_code=status.HTTP_200_OK)
  
# 4) 헬스체크 
@app.get("/healthz", summary="헬스체크")
async def healthz():
    return JSONResponse({"message": "ok"}, status_code=status.HTTP_200_OK)