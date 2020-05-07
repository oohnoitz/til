import Prism from 'prismjs'

const LiveHooks = {}

LiveHooks.CodeHighlight = {
  init() {
    const containers = this.el.querySelectorAll('code')

    for (let i = 0; i < containers.length; i++) {
      Prism.highlightElement(containers[i])
    }
  },
  mounted() {
    this.init()
  },
  updated() {
    this.init()
  },
}

LiveHooks.Editor = {
  init() {
    this.style = {}

    this.observer = new MutationObserver((mutations) => {
      mutations.forEach((mutation) => {
        this.style.height = mutation.target.style.height
        this.style.width = mutation.target.style.width
      })
    })
  },
  mounted() {
    const element = this.el.querySelector('[data-editor]')

    if (element) {
      this.init()
      this.observer.observe(element, {
        attributes: true,
        attributeFilter: ['style'],
      })
    }
  },
  updated() {
    const element = this.el.querySelector('[data-editor]')

    if (element) {
      Object.assign(element.style, this.style)
    }
  },
  beforeDestroy() {
    this.observer.disconnect()
  },
}

export default LiveHooks
