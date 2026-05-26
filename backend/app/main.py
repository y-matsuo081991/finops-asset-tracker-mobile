from fastapi import FastAPI
from fastapi.responses import JSONResponse

app = FastAPI(
    title="FinOps Asset Tracker API",
    description="API for tracking cloud infrastructure costs and asset valuation. (Synthetic Data Only)",
    version="1.0.0",
)

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
