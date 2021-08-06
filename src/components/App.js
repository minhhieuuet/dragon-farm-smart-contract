import React, { Component } from "react";
import Web3 from "web3";
import logo from "../logo.png";
import "./App.css";
import Color from "../abis/Color.json";
import dragon from "./images/dragon.png";
import childDragon from "./images/child-dragon.png";
class App extends Component {
  async componentWillMount() {
    await this.loadWeb3();
    await this.loadBlockchainData();
  }

  async loadBlockchainData() {
    const web3 = window.web3;
    //Load user account
    const accounts = await web3.eth.getAccounts();
    this.setState({ account: accounts[0] });
    const networkId = await web3.eth.net.getId();
    const networkData = Color.networks[networkId];
    if (networkData) {
      const abi = Color.abi;
      const address = networkData.address;
      let contract = new web3.eth.Contract(abi, address);
      this.setState({
        contract,
      });
      const totalSupply = (
        await contract.methods.totalSupply().call()
      ).toNumber();
      this.setState({ totalSupply });
      // console.log(totalSupply);
      for (let i = 0; i < totalSupply; i++) {
        let color = await contract.methods.colors(i).call();
        const address = await contract.methods.ownerAddresses(i).call();
        console.log(address);
        this.setState({
          colors: [
            ...this.state.colors,
            {
              color: color,
              address: address,
            },
          ],
        });
      }
      console.log(this.state.colors);
    } else {
      // alert("Smart contract is not deployed yet");
      window.ethereum
        .request({
          method: "wallet_addEthereumChain",
          params: [
            {
              chainId: "0x61",
              chainName: "Binance Smart Chain- Tesnet",
              nativeCurrency: {
                name: "Binance Coin",
                symbol: "BNB",
                decimals: 18,
              },
              rpcUrls: ["https://data-seed-prebsc-1-s1.binance.org:8545/"],
            },
          ],
        })
        .catch((error) => {
          console.log(error);
        });
    }
  }

  async loadWeb3() {
    if (window.ethereum) {
      window.web3 = new Web3(window.ethereum);
      await window.ethereum.enable();
    } else if (window.web3) {
      window.web3 = new Web3(window.web3.currentProvider);
    } else {
      window.alert(
        "Non ethereum detected. Please download and install MetaMask"
      );
    }
  }

  async mint(color) {
    try {
      const result = await this.state.contract.methods.mint("#" + color).send(
        {
          from: this.state.account,
          value: window.web3.utils.toWei("0.5", 'ether')
        },
        async () => {
          await this.loadBlockchainData();
          // window.location.reload();
        }
      );
    } catch (err) {
      // alert(err);
      console.log(err);
    }
  }

  async mintCouple() {
    let newColor = this.mix_hexes(
      this.state.couple[0].color,
      this.state.couple[1].color
    );
    await this.mint(newColor.replace("#", ""));
  }

  selectForMate(color) {
    if (this.state.couple.length < 2) {
      this.setState({
        couple: [...this.state.couple, color],
      });
    } else {
      this.setState({
        couple: [color],
      });
    }
  }
  hex2dec(hex) {
    return hex
      .replace("#", "")
      .match(/.{2}/g)
      .map((n) => parseInt(n, 16));
  }

  rgb2hex(r, g, b) {
    r = Math.round(r);
    g = Math.round(g);
    b = Math.round(b);
    r = Math.min(r, 255);
    g = Math.min(g, 255);
    b = Math.min(b, 255);
    return "#" + [r, g, b].map((c) => c.toString(16).padStart(2, "0")).join("");
  }

  rgb2cmyk(r, g, b) {
    let c = 1 - r / 255;
    let m = 1 - g / 255;
    let y = 1 - b / 255;
    let k = Math.min(c, m, y);
    c = (c - k) / (1 - k);
    m = (m - k) / (1 - k);
    y = (y - k) / (1 - k);
    return [c, m, y, k];
  }

  cmyk2rgb(c, m, y, k) {
    let r = c * (1 - k) + k;
    let g = m * (1 - k) + k;
    let b = y * (1 - k) + k;
    r = (1 - r) * 255 + 0.5;
    g = (1 - g) * 255 + 0.5;
    b = (1 - b) * 255 + 0.5;
    return [r, g, b];
  }

  mix_cmyks(...cmyks) {
    let c =
      cmyks.map((cmyk) => cmyk[0]).reduce((a, b) => a + b, 0) / cmyks.length;
    let m =
      cmyks.map((cmyk) => cmyk[1]).reduce((a, b) => a + b, 0) / cmyks.length;
    let y =
      cmyks.map((cmyk) => cmyk[2]).reduce((a, b) => a + b, 0) / cmyks.length;
    let k =
      cmyks.map((cmyk) => cmyk[3]).reduce((a, b) => a + b, 0) / cmyks.length;
    return [c, m, y, k];
  }

  mix_hexes(...hexes) {
    let rgbs = hexes.map((hex) => this.hex2dec(hex));
    let cmyks = rgbs.map((rgb) => this.rgb2cmyk(...rgb));
    let mixture_cmyk = this.mix_cmyks(...cmyks);
    let mixture_rgb = this.cmyk2rgb(...mixture_cmyk);
    let mixture_hex = this.rgb2hex(...mixture_rgb);
    return mixture_hex;
  }
  constructor(props) {
    super(props);
    this.state = {
      account: "",
      contract: null,
      totalSupply: 0,
      colors: [],
      couple: [],
    };
  }
  render() {
    return (
      <div>
        <nav className="navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow">
          <a
            className="navbar-brand col-sm-3 col-md-2 mr-0"
            href="#"
            target="_blank"
            rel="noopener noreferrer"
          >
            Create your own Dragon
          </a>
          <a
            style={{
              right: "10px",
              color: "white",
              position: "fixed",
              zIndex: 1000,
            }}
          >
            {this.state.account ? (
              <div>
                Account: <b>{this.state.account}</b>
                <button>Exit</button>
              </div>
            ) : (
              <div>
                <button
                  onClick={async () => {
                    await this.loadBlockchainData();
                  }}
                >
                  Connect Wallet
                </button>
              </div>
            )}
          </a>
        </nav>
        <div className="container-fluid mt-5">
          <div className="row">
            <main role="main" className="col-lg-12 d-flex text-center">
              <div className="content mr-auto ml-auto">
                <form
                  onSubmit={(event) => {
                    event.preventDefault();
                    const color = this.color.value;
                    this.mint(color);
                  }}
                >
                  <b>Create your own dragon</b>
                  <br />
                  {this.state.color}
                  <b>#</b>

                  <input
                    type="text"
                    placeholder="Please input gene"
                    ref={(input) => {
                      // console.log(input)
                      this.color = input;
                    }}
                  ></input>
                  <input type="submit" value="Submit"></input>
                </form>
                <br />
                Total NFT: <b>{this.state.colors.length}</b>
                <br />
                Your NFT:{" "}
                <b>
                  {
                    JSON.parse(JSON.stringify(this.state.colors)).filter(
                      (color) => color.address == this.state.account
                    ).length
                  }
                </b>
                <div
                  style={{
                    display: "flex",
                    flexFlow: "row wrap",
                  }}
                >
                  {this.state.colors.map((color) => (
                    <div
                      className={
                        this.state.account != color.address
                          ? "card"
                          : "card card-owner"
                      }
                    >
                      {this.state.account == color.address && (
                        <div className="title">
                          <b>Your dragon</b>
                        </div>
                      )}
                      <div
                        style={{
                          width: "150px",
                          overflowWrap: "break-word",
                          height: "130px",
                          marginTop: "20px",
                        }}
                      >
                        Owner:
                        {this.state.account == color.address ? (
                          <b>{color.address}</b>
                        ) : (
                          color.address
                        )}
                      </div>
                      <div
                        style={{
                          width: "150px",
                          height: "150px",
                          margin: "10px",
                          background: color.color,
                          // display: "inline-block",
                          overflowWrap: "break-word",
                          cursor:
                            this.state.account != color.address
                              ? "not-allowed"
                              : "pointer",
                          borderTop:
                            this.state.account != color.address
                              ? "none"
                              : "4px solid red",
                          // padding: "10px"
                        }}
                        className={
                          this.state.account != color.address
                            ? "dragon"
                            : "dragon own-dragon"
                        }
                        onClick={() => {
                          if (this.state.account !== color.address) return;
                          this.selectForMate(color);
                        }}
                      >
                        <img
                          style={{
                            width: "150px",
                            height: "150px",
                          }}
                          src={dragon}
                        />
                        Gene: <b className="gene">{color.color}</b>
                      </div>
                    </div>
                  ))}
                </div>
                <br />
                <div
                  style={{
                    padding: "50px",
                    textAlign: "center",
                  }}
                  className="mate-room"
                >
                  <h2>
                    <b>DragonBreeding</b>
                  </h2>
                  {!!this.state.couple.length && (
                    <div style={{ display: "flex" }}>
                      {this.state.couple.length >= 1 && (
                        <div
                          style={{
                            width: "150px",
                            height: "150px",
                            margin: "10px",
                            background: this.state.couple[0].color,
                            alignItems: "center",
                            verticalAlign: "center",
                            // display: "inline-block",
                            overflowWrap: "break-word",
                            // margin: "0px auto",
                          }}
                        >
                          <img
                            style={{
                              width: "150px",
                              height: "150px",
                            }}
                            src={dragon}
                          />
                          Gene: <b>{this.state.couple[0].color}</b>
                        </div>
                      )}
                      <div
                        style={{
                          lineHeight: "185px",
                          fontSize: "80px",
                        }}
                      >
                        +
                      </div>
                      {this.state.couple.length == 2 && (
                        <div
                          style={{
                            width: "150px",
                            height: "150px",
                            margin: "10px",
                            background: this.state.couple[1].color,
                            // display: "inline-block",
                            overflowWrap: "break-word",
                            margin: "0px auto",
                          }}
                        >
                          <img
                            style={{
                              width: "150px",
                              height: "150px",
                            }}
                            src={dragon}
                          />
                          Gene: <b>{this.state.couple[1].color}</b>
                        </div>
                      )}
                      <div
                        style={{
                          lineHeight: "185px",
                          fontSize: "80px",
                          margin: "0px auto",
                        }}
                      >
                        =
                      </div>
                      <div
                        style={{
                          lineHeight: "120px",
                          // fontSize: "80px",
                          marginLeft: "50px",
                          margin: "0px auto",
                        }}
                      >
                        {" "}
                        {this.state.couple.length == 2 && (
                          <div>
                            <img
                              src="https://i.pinimg.com/originals/57/5d/23/575d234f4abedd1875cf71416a3ea9c6.png"
                              style={{
                                width: "120px",
                                height: "120px",
                                marginRight: "10px",
                                marginTop: "43px",
                              }}
                            />
                            <p>
                              Gene:{" "}
                              <b>
                                {this.mix_hexes(
                                  this.state.couple[0].color,
                                  this.state.couple[1].color
                                ) + ""}
                              </b>
                            </p>
                          </div>
                        )}{" "}
                      </div>
                      {this.state.couple.length == 2 && (
                        <div>
                          <div
                            style={{
                              width: "100px",
                              height: "100px",
                              margin: "10px",
                              marginTop: "40px",
                              background: this.mix_hexes(
                                this.state.couple[0].color,
                                this.state.couple[1].color
                              ),
                              // display: "inline-block",
                              overflowWrap: "break-word",
                              // padding: "10px"
                            }}
                          >
                            <img
                              style={{
                                width: "100px",
                                height: "100px",
                              }}
                              src={childDragon}
                            />
                            Gene:{" "}
                            <b>
                              {this.mix_hexes(
                                this.state.couple[0].color,
                                this.state.couple[1].color
                              ) + ""}
                            </b>
                          </div>
                          <div
                            style={{
                              width: "150px",
                              height: "150px",
                              margin: "10px",
                              marginTop: "48px",
                              margin: "0px auto",
                              background: this.mix_hexes(
                                this.state.couple[0].color,
                                this.state.couple[1].color
                              ),
                              // display: "inline-block",
                              overflowWrap: "break-word",
                              margin: "0px auto",
                            }}
                          >
                            <img
                              style={{
                                width: "150px",
                                height: "150px",
                                margin: "0px auto",
                              }}
                              src={dragon}
                            />
                            Gene:{" "}
                            <b>
                              {this.mix_hexes(
                                this.state.couple[0].color,
                                this.state.couple[1].color
                              ) + ""}
                            </b>
                          </div>
                        </div>
                      )}
                    </div>
                  )}
                  <br />
                  <button
                    onClick={async () => {
                      await this.mintCouple();
                    }}
                  >
                    Mate &#x1F493;
                  </button>
                </div>
              </div>
            </main>
          </div>
        </div>
      </div>
    );
  }
}

export default App;
