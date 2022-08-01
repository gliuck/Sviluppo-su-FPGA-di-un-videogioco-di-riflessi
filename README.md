[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://lbesson.mit-license.org/) 
 [![General badge](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white<SUBJECT>-<STATUS>-<COLOR>.svg)](https://www.linkedin.com/in/luca-lussu-8135a4139/)



# Sviluppo-su-FPGA-di-un-videogioco-di-riflessi :joystick:
In questo lavoro è analizzato il funzionamento e la realizzazione di un videogioco basato su FPGA. Delineati i requisiti si è partiti dalla divisione delle funzioni in sottosistemi. I componenti sono stati descritti in linguaggio VHDL, testati e modificati fino a renderli funzionanti ed infine integrati nel progetto.

https://user-images.githubusercontent.com/48186637/181123723-f11d6001-3eb3-4253-b94d-70e27a6cfbff.mp4

## Regole di gioco :dart:
Con la scheda alimentata il giocatore può avviare una partita agendo sullo switch di accensione (Sw 15), questo spegnerà il led di game over (LED 15) ad indicare che il gioco è iniziato.   
Durante il gioco sui display a 7-segmenti, da tenere in verticale, apparirà una sequenza, indicata dai segmenti accesi A, D e G. Il giocatore deve premere i bottoni relativi ai segmenti accesi (btnD per il segmento sinistro D, btnR per il centrale G e btnU per il destro A) nel display più basso della serie (A0).  
In caso di vittoria il gioco continua, incrementando la difficoltà, in caso di sconfitta o spegnendo il gioco (Sw15), si accenderà il led di game over e i display appariranno spenti, il giocatore può iniziare una nuova partita.

## TOP
Nel Top del sistema avviene il collegamento dei componenti, in seguito approfonditi, mediante segnali interni e assegnazioni dirette nella port map degli stessi. 
L’accensione del videogioco avviene quando l’utente alza l’ingresso onsw (Switch di accensione), il Controller porta il segnale Enable da basso ad alto ad indicare che il gioco è in corso, il ledgo (LED di game over) controllato dal segnale di Enable negato, con l’aggiunta di una porta NOT, viene spento. Viene invece acceso il segnale di temporizzazione clk_game, prodotto dividendo il clock di ingresso clk. Ricevendo il suo segnale di clock il Random Generator (Top_lfsr) inizia a produrre sequenze di 3 bit in ingresso al TopDisplay, che si occupa di mostrarle a schermo. Quest’ultimo componente agisce sui segnali di controllo dei display a 7-segmenti, il segnale clk_display è usato per controllarne la frequenza di aggiornamento. L’uscita an a 4 bit per l’accensione sequenziale dei display mentre seg a 3 bit per accendere i segmenti. In uscita restituisce anche i 3 bit vincenti per un dato ciclo di clock, con il segnale dataout. Il sottosistema Game controlla che i dati inseriti dal giocatore tramite i bottoni btn corrispondano a quelli vincenti; in caso contrario viene alzato il segnale di game_over, Enable torna allo stato logico basso, il led di game over viene acceso, il TopDisplay resettato e il clk_game spento. Riportare l’onsw basso riporta il segnale game_over a 0 e permette poi di iniziare una nuova partita. 
I segnali di uscita Alto e AltoDot sono inizializzati con tutti i bit ad 1, la loro funzione è di tenere spenti i segmenti non utilizzati del display. 

![image](https://user-images.githubusercontent.com/48186637/182153481-4fe96739-a9ba-465f-a3a4-911268499f54.png)
![image](https://user-images.githubusercontent.com/48186637/182153516-e94f3ae5-cc32-4d50-9aea-5b22398fcdf7.png)
> Schema circuitale RTL del TOP 

## CLOCK
Il componente Clock si occupa di fornire al sistema i segnali di temporizzazione. In ingresso al blocco sono presenti un segnale di clock esterno clk_in e il segnale di Enable, le uscite sono due segnali di temporizzazione, il primo, clk_display con un periodo di 6.8 ms è utilizzato per il refresh dei display. Il secondo clk_game è il segnale usato da tutti i blocchi sincroni del sistema e può variare la sua frequenza. 
Internamente il componente è realizzato con 3 divisori di frequenza. Il primo contiene un IP Xilinx, il Wizard Clocking, in configurazione MMCM (Mixed-Mode Clock Manager), personalizzato con l'interfaccia fornita dal software per portare la frequenza di 100 MHz in ingresso a 5 MHz in uscita. Sempre in uscita si trova un segnale locked che viene portato alto quando il clock di uscita è stabile, questo viene usato per abilitare il passaggio del clock al divisore successivo tramite una porta AND.

Il secondo divisore Div2 riduce la frequenza da 5 MHz a 5 kHz, ed è stato realizzato con un contatore. All’interno di un processo, attivato dal clock a 5 MHz, tramite uno statement if, ad ogni fronte di salita un variabile interna di tipo Integer viene incrementata di 1 fino al raggiungimento di un valore di soglia posto a 500, che provoca l’inversione dell’uscita, inizializzata bassa, generando il segnale di clock a frequenza minore.
Il terzo divisore, Div3, infine contiene due contatori ognuno responsabile per uno dei segnali di temporizzazione di uscita. Counter2 genera il segnale clk_display a 147 Hz ed è realizzato analogamente a Div2 variando solo la soglia, qui posta a 17.  
Il Counter1 genera invece il segnale clk_game con periodo variabile da 3 ad 1 secondo, presenta in ingresso anche il segnale Enable, usato come clear. In VHDL questo è descritto con un processo nella cui sensitivity list troviamo il clock a 5 kHz ed Enable. Quando Enable è a 0, l’uscita viene tenuta bassa e le variabili interne sono inizializzate con i valori iniziali. Con Enable alto, tramite degli statement if annidati, ad ogni ciclo di clock viene incrementata di 1 la variabile count, giunta al valore espresso dalla variabile countto avviene una commutazione dell’uscita e viene incrementata la variabile points. Quando la variabile points raggiunge un valore stabilito a 10, che corrisponde a 5 vittorie consecutive del giocatore, viene diminuito il valore di countto, riducendo di 0.2 s il periodo del clock di uscita fino ad un minimo di 1s.

## Registro a scorrimento a retroazione lineare (LFSR) :game_die:
L’uso del LFSR si è rivelato fondamentale per il nostro obiettivo di realizzare in maniera casuale l’accensione dei segmenti e quindi di testare i riflessi del giocatore. Nel progetto si è utilizzato il medesimo blocco con l’intenzione di generare dei numeri pseudo-casuali, in modo da poter accendere i segmenti dei Display usati in verticale (D, G, A) con sequenze casuali. 
Il blocco LFSR può essere grande N bit, il numero di Flip Flop D da cui è composto varia in base alla grandezza del registro N desiderato, ed infine ad alcuni stati vengono restituiti al sistema tramite più XOR logici.
Poiché il funzionamento del registro è di tipo deterministico, ha un numero finito di possibili stati, in quanto alla fine si entrerà in un ciclo ripetitivo. Scegliendo una funzione di feedback ben scelta può produrre una sequenza di bit che appare casuale e ha un ciclo molto lungo. Il bit più a destra dell’LFSR è il bit di output, tra un flip flop ed un altro vengono sottoposti ad uno XOR in sequenza con il bit di output e reinseriti nel bit più a sinistra, i bit nello stato che influenzano l’input sono chiamati taps.
La lunghezza massima di un LFSR produce una sequenza N, ovvero scorre tutti i possibili 2^N – 1 stati del registro, a meno che non contenga tutti zeri, in questo caso non cambierà mai. 
Nel nostro caso abbiamo inizializzato il primo bit diverso da zero per generare una sequenza casuale, mettendo in uscita dal blocco out_b che prende solo gli ultimi 3 bit dalla sequenza di 8 bit generata ed inviata al Top_Display per la visualizzazione e la scelta dei segmenti da accendere. Il blocco considerato ha un solo ingresso ovvero il clock e una sola uscita out_b e possiamo notare il suo funzionamento nella Fig. 6, dove notiamo che per ogni fronte positivo di clock l’uscita out_reg da 8 bit cambia in modo casuale grazie agli XOR inseriti in retroazione e riportati in ingresso tramite una concatenazione dell’ultimo bit che esce dallo XOR e i restanti 7 bit di out_reg.

![image](https://user-images.githubusercontent.com/48186637/182154090-bf347a7a-90c1-4a2b-8163-808e4e9a7f3d.png)
> Schema RTL del LFSR 8 bit realizzato

## Controller :video_game:
Per quanto riguarda la funzionalità del blocco Controller dopo svariate modifiche al codice, riusciamo attraverso una semplice mappa di karnaugh a ricavare la funzione corretta per l’uscita Enable.
enable <= onswitch and not (game_over_signal)
Il blocco è così composto, in ingresso abbiamo game_over e sw, in uscita abbiamo enable. Il medesimo blocco ha il compito di avviare il gioco se sw = 1 e game_over = 0, portando l’enable = 1 in uscita così che il segnale possa attivare il blocco del clock, enable svolge il ruolo di clear per i componenti Clock e  Top_Display e spegnere il LED sopra lo SW (led U16). In tal caso arrivasse dal Blocco Game un game_over = 0 (ovvero il giocatore ha perso), Controller manda in uscita enable = 0 che permette di fermare / resettare il gioco nei successivi blocchi e accendere il led U16 per notificare al giocatore che ha perso. Possiamo notare il funzionamento del blocco in Fig. 9, notando che quando lo sw=1 e game_over = 0 allora enable si attiva portandosi a 1 in modo da poter  far partire il blocco del Clock, Top_Display e spegnere il led (per far capire che il gioco è iniziato), caso contrario arrivasse un game_over = 1, enable torna al suo valore iniziale = 0 azzerando il blocco Clock e accendendo i led, segnalando in questo modo al giocatore che ha perso.

## Game
In fase di progettazione del blocco Game si è deciso di strutturare così il blocco, ovvero con ingresso un Clkg_in che viene prelevato da clk_game il clock alla frequenza desiderata, nel nostro caso dopo svariati test si è deciso di avere un Clock ogni 3 secondi per iniziare il gioco modalità semplice. Altro ingresso btn che corrisponde ai 3 pulsanti con cui il giocatore interagisce (U17, W19, T18), data_in è un ingresso che viene dato dall’uscita dal Top_Display che ci permette di conoscere i segmenti accesi sul display A0, l’ingresso onsw  è il nostro switch (R2) che ci permette di avviare il gioco o resettare e riiniziare il gioco, infine l’uscita game_over che ci permette di fermare il gioco.
Il funzionamento del blocco è avviare il gioco quando onsw = 1, se game_over = 0   il giocatore deve poter continuare a giocare, il blocco si occuperà di verificare ad ogni evento di clock se i pulsanti premuti sono i medesimi visualizzati nel display a 7 segmenti, in caso contrario game_over bloccherà il gioco.
Per verificare l’uguaglianza tra i pulsanti e i segmenti attivi, è necessario inserire 3 Flip Flop D (uno per ogni bit data_in), come possiamo notare dalle figure 12 e 13, nella simulazione del funzionamento Game il segnale q_out che rappresenta l’uscita dei flip flop, campiona sul fronte di discesa, prendono il segnale che andrebbe perso se campionato in fase di salita, perché con il positivedge avrei confrontato i nuovi dati, così facendo riusciamo al prossimo fronte positivo di clock a verificare l’uguaglianza tra q_out e btn mandando avanti il gioco se rispettato.
Dalla figura 12 possiamo approfondire il funzionamento di Game, con onsw = 1 il gioco ha inizio, arrivano i vari valori apparsi nei segmenti tramite il segnale data_in, nell’esempio in figura arriva un 3, che successivamente sul fronte di discesa viene portato su q_out pronto a essere confrontato con il segnale btn sul prossimo fronte di salita del clock, se  i  due segnali btn e q_out sono uguali allora il gioco continua, altrimenti come per il dato successivo data_in = 5 si attiva alto game_over fermando il gioco.

![image](https://user-images.githubusercontent.com/48186637/182154278-ede84c3c-e63d-4dda-a664-849ac885b10d.png)
> Rtl blocco Game
![image](https://user-images.githubusercontent.com/48186637/182154357-9500531d-e093-4aee-b080-4e77534664af.png)
> Simulazione Funzionamento Game

## TOPDisplay
Il blocco TopDisplay si occupa del controllo della parte visiva dell’applicazione, nel dettaglio la sua funzione è quella controllare i 4 display a 7-segmenti, in ordine dall’alto al basso (A3, A2, A1, A0). All’interno di questo blocco troviamo una memoria, Mem, in cui sono salvati i dati relativi ai segmenti da illuminare e un sistema DispGame che si interfaccia ai display e determina la loro accensione e dei relativi segmenti. Il segnale data_out trasporta all’esterno i 3 bit mostrati nel display in basso A0, ovvero la sequenza di gioco. 
Mem: Si tratta di uno shift-register di tipo SIPO, serial input parallel output, con reset asincrono attivo basso. La memoria si compone di 4 righe, ognuna corrispondente ad un display e 3 colonne, ognuna relativa ad un segmento (in ordine dal bit 2 allo 0: D, G ed A). All’interno di essa vengono salvati i dati provenienti dal generatore casuale. Il suo comportamento è descritto da un processo che dipende dal clock di ingresso e dal clear chiamato nreset che quando basso resetta la memoria. Quando il segnale nreset è alto sul fronte di salita del clock ogni riga copia il valore di quella precedente, l’ultima acquisisce i nuovi bit. I dati nei registri vengono concatenati ed escono come un unico segnale a 12 bit.
DispGame: È lo stadio finale per il controllo dei display, si tratta di un multiplexer controllato dallo stesso segnale a 4 bit an, generato in Counter4, e permette il passaggio al corrispondente segnale a 3 bit ottenuto dalla memoria. Quando risulta acceso il display in alto A3, il multiplexer passa in uscita i primi 3 bit del segnale input, il display A0 acceso passano negati all’uscita gli ultimi 3 bit.  Le uscite del multiplexer sono negate poiché, mentre nella memoria è stato considerato alto il segnale acceso, affinché un segmento sia acceso il suo segnale di controllo deve essere basso. Nell’eventualità che il segnale di controllo sia diverso da uno dei 4 stati di Counter4, all’uscita viene passato un segnale con i 3 bit a 0, in modo da far risultare il display spento. 
Counter4: Questo componente ha il compito di accendere in sequenza gli anodi del display, alla frequenza fornita da clk_display, per permettere al giocatore di vedere correttamente. Per farlo conta attraverso una sequenza nota, partendo dal valore da cui è inizializzato 1110, che corrisponde ad accendere il display A0, lo 0 viene traslato a sinistra ad ogni fronte di salita del clock, accendendo in ordine anche A1, A2 e A3.

![image](https://user-images.githubusercontent.com/48186637/182154532-49bdfc98-edcf-4c5e-b1bf-40de4f6e357f.png)
> Simulazione post-implementation timing TopDisplay, sul fronte di salita di clk_int_1 che corrisponde a clk_game, il dato inserito 4 cicli prima arriva nell’ultima riga della memoria, dataout passa quindi a 0x3. Sul display A0, an=0xE, compare dataout negato 0x4.

## Implementation
Le risorse utilizzate per implementare il sistema sulla FPGA sono limitate. Poiché la maggior parte dei pad I/O utilizzati si trova nella regione X1Y0, sono state piazzati in questa anche la maggior parte delle Leaf Cell nelle regioni X0Y0 e X1Y1, sono invece presenti rispettivamente i pad I/O dei bottoni e del led ledgo. La distribuzione del clock parte dal pad W5, il blocco MMCME2 della regione X1Y0, utilizzato dal Clocking Wizard che porta la sua uscita, il clock a 5 MHz, verso i buffer globali.
Una delle vicine LUT è usata per implementare l’AND che genera il clock abilitato dal segnale locked, anch'esso utilizza un buffer globale e viene distribuito alle vicine CLB dove è implementato il secondo divisore. Il clock a 5 kHz così generato passa per il terzo buffer globale e da esso viene distribuito al divisore 3, implementato nella regione X1Y0 vicino alle uscite, responsabile dei segnali clk_display e clk_game.
Il consumo del sistema è modesto, 0.155 W, il 56% della potenza dissipata è stata dinamica il restante 44% (0.069 W) statica. La potenza dinamica è utilizzata al 99% dall’utilizzo del Clocking Wizard, il resto è utilizzato da segnali I/O e dalla logica.

## Conclusione
Dopo aver integrato i componenti singolarmente testati sono state effettuate delle simulazioni behavioral per verificare il corretto funzionamento del sistema, poiché il videogioco è relativamente lento è stato preferito effettuare i test finali direttamente sulla scheda.  Per rendere il gioco portatile un’unità flash USB è stata formattata nel file system FAT32 inserendo il solo file di bitstream, il jumper JP1 è stato posto in modalità USB e l’alimentazione fornita da un powerbank.










