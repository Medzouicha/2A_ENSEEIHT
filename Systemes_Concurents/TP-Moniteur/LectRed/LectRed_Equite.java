// Time-stamp: <28 oct 2022 09:24 queinnec@enseeiht.fr>

import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import Synchro.Assert;

/** Lecteurs/rédacteurs
 * stratégie d'ordonnancement: priorité aux rédacteurs,
 * implantation: avec un moniteur. */
public class LectRed_Equite implements LectRed
{
    private ReentrantLock mon;
    private Condition lecture;
    private Condition ecriture;
    private int nbL;
    private int nbLA;
    private int nbR;
    private int nbRA;
    private boolean red;



    public LectRed_Equite() {
        this.mon = new ReentrantLock ();
        this.lecture = mon.newCondition();
        this.ecriture = mon.newCondition();
        this.red = false;
        this.nbL = 0;
        this.nbLA = 0 ;
        this.nbR = 0 ;
        this.nbRA = 0;



    }

    public void demanderLecture() throws InterruptedException {
        mon.lock();
        while(this.nbR > 0 || this.nbRA > 0 || this.nbLA > 0){
            this.nbLA ++;
            lecture.await();
            this.nbLA --;
        }
        this.nbL++;
        this.lecture.signal();
        this.mon.unlock();
        }
    

    public void terminerLecture() throws InterruptedException {
        mon.lock();
        this.nbL --;
        if (this.nbL == 0){
            if (this.nbRA > this.nbLA){
                 lecture.signal();
            } else {
                ecriture.signal();
            }
           
        }
        mon.unlock();
    }

    public void demanderEcriture() throws InterruptedException {
        mon.lock();
        while (this.nbL > 0 || this.nbRA > this.nbLA){
            this.nbLA ++;
            lecture.await();
            this.nbLA --;
            if (this.nbL > 0 || this.nbLA > this.nbRA){
                this.nbRA ++;
                ecriture.await();
                this.nbRA --;
            }
        }
        this.nbR ++ ;
       
        mon.unlock();
    }

    public void terminerEcriture() throws InterruptedException {
        mon.lock();
        this.nbR --;
      
        this.lecture.signal();
        
        mon.unlock();
    }

    public String nomStrategie() {
        return "Stratégie: Priorité Rédacteurs.";
    }
}