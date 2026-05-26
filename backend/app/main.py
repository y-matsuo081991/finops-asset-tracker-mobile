from fastapi import FastAPI
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware

from app.interfaces.api.rest import nodes

app = FastAPI(
    title="FinOps Asset Tracker API",
    description="API for tracking cloud infrastructure costs and asset valuation. (Synthetic Data Only)",
    version="1.0.0",
)

# モバイルからのアクセスを許可するためのCORS設定
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(nodes.router, prefix="/api/v1")

@app.get("/health", summary="Health Check")
async def health_check():
    """
    システムの正常稼働を確認するためのヘルスチェックエンドポイント
    """
    return JSONResponse(
        content={
            "status": "healthy",
            "message": "FinOps Asset Tracker API is running.",
        }
    )

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
