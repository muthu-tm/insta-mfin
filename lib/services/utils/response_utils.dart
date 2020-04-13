class CustomResponse {
  static getSuccesReponse(message) {
    return {"is_success": true, "message": message};
  }

  static getFailureReponse(message) {
    return {"is_success": false, "message": message};
  }
}
