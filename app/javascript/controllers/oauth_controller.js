import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { 
    codeVerifier: String,
    clientId: String,
  }

  connect() {
    // add codeVerifier from sessionStorage
    // use traceId in key if you run into collisions
    sessionStorage.setItem("codeVerifier", this.codeVerifierValue)
    sessionStorage.setItem("clientId", this.clientIdValue)
  }
}
