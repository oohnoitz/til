function setupAlerts() {
  const alertsCloseButtons = document.querySelectorAll('[data-alert-close]')

  for (let i = 0; i < alertsCloseButtons.length; i++) {
    alertsCloseButtons[i].addEventListener('click', e => {
      e.stopPropagation()
      const alert = e.currentTarget

      alert.parentNode.removeChild(alert)
    })
  }
}

function setup() {
  setupAlerts()
}

export default {
  setup,
}
