import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["clientId", "codeVerifier", "form"]

  connect() {
    console.log("we here dawg")
    const clientId = sessionStorage.getItem("clientId")
    const codeVerifier = sessionStorage.getItem("codeVerifier")

    this.clientIdTarget.value = clientId
    this.codeVerifierTarget.value = codeVerifier

    // if something's gone wrong and we don't have a verifier or clientId
    if (!clientId || !codeVerifier) {
      console.error("Missing clientId or codeVerifier in sessionStorage, try flow again...")
      window.location.href = "/?error=sessionStorage-error"
    }
  }
}
