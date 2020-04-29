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
    this.style = {
      height: null,
    }
  },
  mounted() {
    this.init()

    const observer = new MutationObserver((mutations) => {
      mutations.forEach((mutation) => {
        this.style.height = mutation.target.style.height
      })
    })

    observer.observe(
      this.el.querySelector('[data-editor]'),
      {
        attributes: true,
        attributeFilter: ['style'],
      }
    )
  },
  updated() {
    if (this.style.height) {
      this.el.querySelector('[data-editor]').style.height = this.style.height
    }
  },
}

export default LiveHooks
