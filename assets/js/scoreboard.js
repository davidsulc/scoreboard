let Scoreboard = {
  init(socket) {
    let channel = socket.channel('scoreboard:lobby', {});
    channel.join();
    this.listenForScoreboardUpdates(channel);
  },

  listenForScoreboardUpdates(channel) {
    channel.on('update', payload => {
      console.log("got update on channel: ", payload);
      let scoreEl = document.querySelector('#score');
      if(scoreEl){
        scoreEl.innerHTML = `${payload.score.left} - ${payload.score.right}`;
      }
    })
  }
}

// export default Scoreboard
