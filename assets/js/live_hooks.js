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

export default LiveHooks
